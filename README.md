
# iOS Cocoa Layout in practice
Here are presented examples of using UIKit, SwiftUI, Cocoa Layout, Xib and Nib explanations, SwiftUI + Xib, Combine, CoreData+SwiftUI

# Article: iOS Cocoa Layout in practice
Cocoa Layout will be explained with a very easy example called MyRecipes where you can manage your favorite recipes.

The letter first published at the [Medium.com](https://medium.com/@sergeykrotkih/some-ios-cocoa-layout-job-interview-questions-in-practice-d371c70cbbb5). Follow me for more content like this and don't forget to drop a clap if you like it :)
Another publish at the [CodeProject](https://www.codeproject.com/script/Articles/ArticleVersion.aspx?waid=4270741&aid=5353232)
My [Linkedin profile](https://www.linkedin.com/in/serhii-krotkykh-2746a420/)

## What is difference between Xib and Nib files?

Let’s create a new Xcode project called MyRecipes: 

<img alt="picture 1" align="center" src="/Resources/picture 1.png">

Enter into the new project. Rename ViewController to RecipesViewController. Open main.storyboard. Select ViewController. Choice RecipesViewController on the Identity Inspector. Add UITableView to the view controller. Make shure the table view has just one Prototype Cell. Let’s call it ‘cell’: 

<img alt="picture 2" align="center" src="/Resources/picture 2.png">

Add to the projet a new Cocoa Touch Class file RecipeItemView:

<img alt="picture 3" align="center" src="/Resources/picture 3.png">

Create Xib file wit the same name:

<img alt="picture 4" align="center" src="/Resources/picture 4.png">

Open the Xib file and update it according the picture: 

<img alt="picture 5" align="center" src="/Resources/picture 5.png">  

There are two files with same name with Swift and Xib (selected on the picture) extencions.
But where is the Nib file?
Nib file is a file which Xcode creates while Xib file compilation.
Nib file has some common format and using for restoring view on run time.
Xcode saves it in the built app folder. Open a folder with path like this:
###˜/Library/Developer/Xcode/DerivedData/MyRecipes-…./Build/Products/Debug-iphonesimulator/MyRecipes
Then open context menu (by right mouse button) and select “Show Package Contents”:

<img alt="picture 6" align="center" src="/Resources/picture 6.png">

## How to use Xib file?

  Xib file associated with user interface. In our case RecipesItemView.xib asociated with RecipesItemView UIView class.
We will use the view as a content view for the Table view cell. So we need download the Nib file, parse it to the RecipesItemView class and add it as a subview to the cell Content view.
There are two way to get view class from nib.  
 
1. Download nib file as an array. Xib file can have one and more ov UIView and even UIViewController. To get them as nib elements, call loadNibNamed function like this:
 ```swift
         let elementsOfNib = Bundle.main.loadNibNamed("RecipeItemView", owner: nil, options: nil)
```         
     The function returns Optional. To get the participate view use index or methods like this: 
```swift         
         let recipesItemView = elementsOfNib?.first
```         
recipesItemView is an optional instance of the RecipesItemView class with initialized outlets.

2. Another method to get element from Nib file is with using owner parameter:
```swift
         Bundle.main.loadNibNamed("RecipeItemView", owner: self, options: nil)
```         
What is the self here and why we are not assign the result to anything? Let's consider that step by step.
Open the RecipeItemView Xib file and assign Placeholders - File's Owner as RecepesViewController:

<img alt="picture 7" align="center" src="/Resources/picture 7.png">

Open RecipesViewController.swift. Add following line: 
```swift
    class RecipesViewController: UIViewController {
       ...
       @IBOutlet var itemView: RecipeItemView!
```
Return to the Xib edit screen. Select File's Owner. Press on the mouse right button. Drag to the RecipesItemView.
Select itemView. So we bound File owner and element of the xib.

<img alt="movie 1" align="center" src="/Resources/movie1.gif">

Let's return to the previous line:
```swift
         Bundle.main.loadNibNamed("RecipeItemView", owner: self, options: nil)
```         
Self is RecipesViewController. After return this function the var itemView will get a value. It's RecipeItemView instance.

## How to make Table view cell auto resizable?

   Bind height constraints of the RecipeItemView's' titleLabel, imageView and descriptionLabel with outlets of  NSLayoutConstraits:

<img alt="picture 9" align="center" src="/Resources/picture 9.png">

Open RecipesViewController. Configure UITableView from the viewDidLoad overrided method:
```swift
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
```

override two UITableViewDelegate methods:
```swift    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
    }
```
Open RecipeItemView.swift. Compute height constraints:
```swift
func configure(with cell: UITableViewCell, model: ReceipeData?, width: CGFloat) {
   guard let model else { return }
   titleLabel.text = model.title
   imageView.image = model.image
   descriptionLabel.text = model.description
   let h1 = model.title?.height(for: width, font: titleLabel.font) ?? 0
   let h2 = model.image?.height(for: width) ?? 0
   let h3 = model.description?.height(for: width, font: descriptionLabel.font) ?? 0
   titleLabelHeight.constant = h1
   imageViewHeight.constant = h2
   descriptionLabelHeight.constant = h3
   let height: CGFloat = h1 + h2 + h3 + 5.0 * 4
   translatesAutoresizingMaskIntoConstraints = false
   NSLayoutConstraint.activate([
     leadingAnchor.constraint(equalTo: cell.leadingAnchor),
     trailingAnchor.constraint(equalTo: cell.trailingAnchor),
     topAnchor.constraint(equalTo: cell.topAnchor),
     bottomAnchor.constraint(equalTo: cell.bottomAnchor),
     heightAnchor.constraint(equalToConstant: height)
   ])
}
```
Next and last step is to prepare UITableViewCell. Override two methods of the UITableViewDataSource delegate:
```swift
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        Bundle.main.loadNibNamed("RecipeItemView", owner: self, options: nil)
        // itemView is laded now. We can use it.
        cell.addSubview(itemView!)
        itemView!.configure(with: cell, model: viewModel[indexPath.row], width: tableView.frame.width)
        return cell
    }
``` 
The table view cells should change their height according to the content.
Let's consider the same answer just for SwiftUI. Create new Xcode project with Interface SwiftUI. Replace main content view by following code:
```swift
struct RecipesContentView: View {
    @EnvironmentObject var viewModel: RecipesFakeData
    var body: some View {
        GeometryReader { geometry in
            VStack {
                NavigationBar()
                List {
                    ForEach(0..<viewModel.count, id: \.self) { index in
                        RecipeRow(index: index, width: geometry.size.width - 30.0)
                            .frame(width: geometry.size.width - 30.0, height: rowHeight(index: index, width: geometry.size.width - 30.0))
                            .background(.black)
                    }
                 }
                .background(.black)
                .scrollContentBackground(.hidden)
            }
            .background(.black)
        }
    }
    
    private func rowHeight(index: Int, width: CGFloat) -> CGFloat {
        if let model = viewModel[index],
           let view = Bundle.main.loadNibNamed("RecipeItemView", owner: nil, options: nil)?.first as? RecipeItemView {
            var height = model.title?.height(for: width, font: view.titleLabel.font) ?? 0
            height += model.image?.height(for: width) ?? 0
            height += model.description?.height(for: width, font: view.descriptionLabel.font) ?? 0
            return height + 5.0 * 3  // see RecipeItemView.xib layout
        }
        return 0.0
    }
}
struct RecipeRow: UIViewRepresentable {
    @EnvironmentObject var viewModel: RecipesFakeData
    typealias UIViewType = RecipeItemView
    private let index: Int
    private let width: CGFloat
    
    init(index: Int, width: CGFloat) {
        self.index = index
        self.width = width
    }

    func makeUIView(context: Context) -> RecipeItemView {
        if let model = viewModel[index],
           let view = Bundle.main.loadNibNamed("RecipeItemView", owner: nil, options: nil)?.first as? RecipeItemView {
            view.titleLabel.text = model.title ?? ""
            view.imageView.image = model.image
            view.descriptionLabel.text = model.description ?? ""
            view.titleLabelHeight.constant = model.title?.height(for: width, font: view.titleLabel.font) ?? 0
            view.imageViewHeight.constant = model.image?.height(for: width) ?? 0
            view.descriptionLabelHeight.constant = model.description?.height(for: width, font: view.descriptionLabel.font) ?? 0
            return view
        }
        return RecipeItemView()
    }
}
```
As you can see on this time we use loadNibNamed method with owner = nil. It returns array with view components.

## Conclusion

MyRecipes app developed with using MVVM pattern. ViewModel published data with Combine PassthroughSubject and the View subscribes on it. View send message to the ViewModel about produce a new recipe data, then gets data and updates the tableView. As a result you should see something like this:
   
<img alt="picture 1" align="center" src="/Resources/myrecipes.gif">

## Requirements

- Xcode 14+
- Swift 5.7

## History

- 17th February 2023: Initial version
- 17th February 2023: Published on the [Medium.com](https://medium.com/@sergeykrotkih/some-ios-cocoa-layout-job-interview-questions-in-practice-d371c70cbbb5)
