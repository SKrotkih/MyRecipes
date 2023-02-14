
# Some iOS Cocoa Layout Job interview Questions in practice

The some job interview questions will be explained on very simple application 
called MyRecipes where you can manage your favorite recipes.

## What is the difference between Xib and Nib files?

  Let’s create a new Xcode project. Call it MyRecipes. 

<img alt="picture 1" align="center" src="/Resources/picture 1.png">

Rename ViewController to RecipesViewController. Open main.storyboard
Select ViewController. Select RecipesViewController on the Identity Inspector. Add UITableView to the view controller. Make shure the table view has just one Prototype Cell. Let's call it 'cell'. 

<img alt="picture 1" align="center" src="/Resources/picture 2.png">

Add to the projet a new Cocoa Touch Class file RecipeItemView:

<img alt="picture 1" align="center" src="/Resources/picture 3.png">

Create Xib file wit the same name:

<img alt="picture 1" align="center" src="/Resources/picture 4.png">

Open the Xib file and update it according the picture: 

<img alt="picture 1" align="center" src="/Resources/picture 5.png">  

There are two files with same name with Swift and Xib (selected on the picture) extencions.
But where is the Nib file? Nib file is a file wich Xcode creates while Xib file compilation.
Nib file has some common format and using for restoring view on run time. 
<img alt="picture 1" align="right" src="/Resources/picture 6.png">   
Xcode saves it in the built app folder. Open a folder with path like this:

###˜/Library/Developer/Xcode/DerivedData/MyRecipes-..../Build/Products/Debug-iphonesimulator/MyRecipes

Then open context menu (by right mouse button) and select "Show Package Contents":
On the picture you can see the Nib file.

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

<img alt="picture 1" align="center" src="/Resources/picture 7.png">

Open RecipesViewController.swift. Add following line: 
```swift
    class RecipesViewController: UIViewController {
       ...
       @IBOutlet var itemView: RecipeItemView!
```
Return to the Xib edit screen. Select File's Owner. Press on the mouse right button. Drag to the RecipesItemView.
Select itemView. So we bound File owner and element of the xib.

<img alt="picture 1" align="center" src="/Resources/picture 8.png">

Let's return to the previous line:
```swift
         Bundle.main.loadNibNamed("RecipeItemView", owner: self, options: nil)
```         
Self is RecipesViewController. After return this function the var itemView will get a value. It's RecipeItemView instance.

## How to make Table view cell auto resizable?

   Bind height constraints of the RecipeItemView's' titleLabel, imageView and descriptionLabel with outlets of  NSLayoutConstraits:

<img alt="picture 1" align="center" src="/Resources/picture 9.png">

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
        func textHeight(of text: String?, width: CGFloat, font: UIFont) -> CGFloat {
            if let text {
                return text.heightWithConstrainedWidth(width: width, font: font)
            } else {
                return 0.0
            }
        }
        func imageHeight(of image: UIImage?, width: CGFloat) -> CGFloat {
            guard let image else { return 0.0 }
            let size = image.size
            let k = width / size.width
            return size.height * k
        }
        guard let model else { return }
        
        titleLabel.text = model.title
        imageView.image = model.image
        descriptionLabel.text = model.description

        var height: CGFloat = 0.0
        let h1 = textHeight(of: model.title, width: width, font: titleLabel.font)
        titleLabelHeight.constant = h1
        height += h1; height += 5.0
        let h2 = imageHeight(of: model.image, width: width)
        imageViewHeight.constant = h2
        height += h2; height += 5.0
        let h3 = textHeight(of: model.description, width: width, font: descriptionLabel.font)
        descriptionLabelHeight.constant = h3
        height += h3; height += 5.0
        
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
The next step is to prepare UITableViewCell. Override two method of the UITableViewDataSource delegate:
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
## Conclusion
    MyRecipes app developed with using MVVM pattern. ViewModel published data with Combine PassthroughSubject and View subscribes on it. View send message to the ViewModel about produce new recipe data, then gets data and updates table view. More details you can see in source code.
   
<img alt="picture 1" align="center" src="/Resources/myrecipes.gif">
