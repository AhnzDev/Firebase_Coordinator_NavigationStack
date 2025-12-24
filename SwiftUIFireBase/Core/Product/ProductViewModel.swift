//
//  ProductViewModel.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 12/12/25.
//
import Foundation
import SwiftUI
import FirebaseFirestore

@MainActor
final class ProductViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published var selectedFilter: FilterOption?
    @Published var selectedCategory: CategoryOption?
    private var lastDocument: DocumentSnapshot? = nil
    
    
    func downloadProductsAndUploadToFirebase() {
        guard let url = URL(string: "https://dummyjson.com/products") else { return }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let products = try JSONDecoder().decode(ProductArray.self, from: data)
                let productArray = products.products
                
                for product in productArray {
                    try? await ProductsManager.shared.uploadProduct(product: product)
                }
                
                print("SUCCESS")
                print(products.products.count)
            } catch {
                print(error)
            }
        }
    }
    //    
    //    func getProducts() {
    //        Task {
    //            do {
    //                products = try await ProductsManager.shared.getAllProducts()
    //            } catch {
    //                print(error)
    //            }
    //        }
    //    }
    
    
    enum FilterOption: String, CaseIterable {
        case noFilter
        case priceHigh
        case priceLow
        
        var priceDescending: Bool? {
            switch self {
            case .noFilter: return nil
            case .priceHigh: return true
            case .priceLow: return false
            }
        }
    }
    
    func filterSelected(option: FilterOption) async throws {
        self.selectedFilter = option
        self.products = []
        self.lastDocument = nil
        getProducts()
        
        //        switch option {
        //        case .noFilter:
        //            self.products = try await ProductsManager.shared.getAllProducts()
        //            self.selectedFilter = option
        //        case .priceHigh:
        //            self.products = try await ProductsManager.shared.getAllProductsSortedByPrice(descending: true)
        //            self.selectedFilter = option
        //        case .priceLow:
        //            self.products = try await ProductsManager.shared.getAllProductsSortedByPrice(descending: false)
        //            self.selectedFilter = option
        //        }
    }
    
    enum CategoryOption: String, CaseIterable {
        case noCategory
        case furniture
        case laptops
        case fragrances
        
        var categoryKey: String? {
            if self == .noCategory {
                return nil
            }
            return self.rawValue
        }
    }
    
    func categorySelected(option: CategoryOption) async throws {
        self.selectedCategory = option
        self.products = []
        self.lastDocument = nil
        getProducts()
        //        switch option {
        //        case .noCategory:
        //            self.products = try await ProductsManager.shared.getAllProductsByPrice(descending: selectedFilter?.priceDescending, category: option.rawValue)
        //            self.categoryFilter = option
        //        case .furniture, .laptops, .fragrances:
        //            self.products = try await ProductsManager.shared.getAllProductsForCategory(category:option.rawValue)
        //            self.categoryFilter = option
        //        }
    }
    
    func getProducts() {
        print("LAST DOC")
        print(lastDocument)
        Task {
            let (newProducts, lastDocument) = try await ProductsManager.shared.getAllProducts(priceDescending: selectedFilter?.priceDescending, forCategory: selectedCategory?.categoryKey, count: 10, lastDocument: lastDocument)
            self.products.append(contentsOf: newProducts)
            if let lastDocument {
                self.lastDocument = lastDocument
            }
            
            print("RETURN DOC")
            print(lastDocument)
        }
    }
    
    func getProductByRating() {
        Task {
            let (newProducts, lastDocument) = try await ProductsManager.shared.getProductsByRating(count: 4, lastDocument: lastDocument)
            self.products.append(contentsOf: newProducts)
            self.lastDocument = lastDocument
        }
    }
    
    func getProductCount() {
        Task {
            let count = try await ProductsManager.shared.getAllProductsCount()
            print("AllCount : \(count)")
        }
    }
    
    func addUserFavoriteProduct(productId: Int) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.addUserFavoriteProduct(userId: authDataResult.uid, productId: productId)
        }
        
    }
}
