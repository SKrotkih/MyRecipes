//
//  RecipesFakeData.swift
//  MyRecipes
//
//  Created by Serhii Krotkykh on 14.02.2023.
//
import UIKit
import Combine

/// The app Model
struct ReceipeData: Codable {
    var id: UUID
    let title: String?
    let imageID: String?
    let description: String?
}

/// Recipes list data source protocol
protocol RecipesListDataSource {
    var isDataUpdated: PassthroughSubject<Void, Never> { get }
    var count: Int { get }
    subscript(index: Int) -> ReceipeData? { get }
    func add()
}

/// Fake test recipes
struct MockData {
    let r1 = """
Directions
Step 1
Preheat oven to 350°. In a small saucepan over medium heat, add beans and 1 cup of water. Bring to a simmer and let simmer until beans are warmed through, about 10 minutes. Smash with a wooden spoon until most of the beans are smashed with some whole remaining. Add more water as needed to help create a smoother consistency.
Step 2
Meanwhile, place tostadas on a large baking sheet and sprinkle cheese evenly over each. Bake until cheese is melty, about 5 minutes.
Step 3
Top tostadas with beans, avocado slices, and hot sauce.
End
"""
    
    let r2 = """
Directions
Step 1
Pat chicken dry with paper towels, then season all over with salt and pepper. In a small bowl, combine cumin, oregano, garlic powder, and cayenne. Rub mixture into chicken.
Step 2
In a large skillet over medium-high heat, heat oil. Add chicken and cook until golden, 5 minutes per side. Remove skillet and reserve on a plate.
Step 3
To same skillet over medium heat, add onion and pepper. Cook until soft, 5 minutes. Add garlic and cook until fragrant, 1 minute more, then stir in tomato paste.
Step 4
Add rice and cook until well coated and toasted, 3 minutes. Pour in chicken broth and diced tomatoes, and bay leaf, stirring up any bits from bottom of pan. Bring to a boil, then add chicken back to skillet. Reduce heat and let simmer, covered, until chicken is cooked through and rice is tender, 30 minutes. Stir occasionally to make sure rice is not sticking to bottom of pan. Add more water or broth as necessary.
Step 5
Remove bay leaf and serve with cilantro.
Step 4
Add rice and cook until well coated and toasted, 3 minutes. Pour in chicken broth and diced tomatoes, and bay leaf, stirring up any bits from bottom of pan. Bring to a boil, then add chicken back to skillet. Reduce heat and let simmer, covered, until chicken is cooked through and rice is tender, 30 minutes. Stir occasionally to make sure rice is not sticking to bottom of pan. Add more water or broth as necessary.
Step 5
Remove bay leaf and serve with cilantro.
End
"""
    
    let r3 = """
Directions
Step 1
Preheat oven to 400°. In a small saucepan, prepare rice according to package instructions. In a large skillet over medium heat, heat oil. Cook onion until soft, about 5 minutes. Stir in tomato paste and garlic and cook until fragrant, about 1 minute more. Add ground beef and cook, breaking up meat with a wooden spoon, until no longer pink, 6 minutes. Drain fat.
End
"""
    
    let tr1 = "Stuffed Peppers"
    let tr2 = "Black Bean Tostadas"
    let tr3 = "Arroz Con Pollo"
    
    let ir1 = "ri1"
    let ir2 = "ri2"
    let ir3 = "ri3"
    
    func randomRecipe() -> ReceipeData {
        let trs = [tr1, tr2, tr3]
        let irs = [ir1, ir2, ir3]
        let rs = [r1, r2, r3]
        
        let r1 = Int.random(in: 0..<3)
        let r2 = Int.random(in: 0..<3)
        let r3 = Int.random(in: 0..<3)

        return ReceipeData(
            id: UUID(),
            title: trs[r1],
            imageID: irs[r2],
            description: rs[r3]
        )
    }
}

/// RecipesFakeData generates fake random recipes
class RecipesFakeData: RecipesListDataSource {
    var isDataUpdated = PassthroughSubject<Void, Never>()
    private var dataSource = [ReceipeData]()
    var count: Int { dataSource.count }
    
    subscript(index: Int) -> ReceipeData? {
        guard dataSource.indices.contains(index) else { return nil }
        return dataSource[index]
    }
    
    func add() {
        let data = MockData().randomRecipe()
        dataSource.append(data)
        isDataUpdated.send(Void())
    }
}
