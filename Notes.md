# View Controller Lifecycle

  1. Instantiated
  2. `awakeFromNib` (only if instantiated from storyboard)
  3. Segue preparation
  4. Outlets set
  5. `viewDidLoad`
  6. `viewWillAppear` and `viewDidAppear`
  7. `viewWillDisappear` and `viewDidDisappear`
  8. On geometry changes: `viewWillLayoutSubviews` and `viewDidLayoutSubviews`
  9. On autolayout changes: `viewWillTransition`
  10. On low memory: `didReceiveMemoryWarning`

## Primary Setup

Always call super during lifecycle methods

`viewDidLoad`:
  - Called once
  - Do not update geometry
  - For primary MVC setup
  - Update view from model, outlets are set

`viewWillAppear`:
  - Called every time controller becomes visible

`viewDidAppear`:
  - Start observing something like GPS position
  - Useful for starting expensive procedures that shouldn't run until visible

`viewWillDisappear`:
  - View still visible, but about to be removed
  - Stop timers or other observing processes 

`viewDidDisappear`:
  - Possible place to clean up state

## Geometry Change Handling

Notification methods for when `layoutSubviews` has been called
These can get called often

`viewWillLayoutSubviews`:
  - Before `layoutSubviews`

`viewDidLayoutSubviews`:
  - After `layoutSubviews`

Autorotation also calls `viewWillTransition` 

`viewWillTransition`:
  - Autorotation has builtin animations that can be hooked into here 
  - Affect animations by using the coordinator's `animate(alongsideTransition:)`

## Low Memory Handling

When a low-memory situation occurs, iOS will call `didReceiveMemoryWarning` to
allow the app to lower its memory footprint

`didReceiveMemoryWarning`:
  - Possibly remove strong pointers to large memory assets
  - If the app continues to use a large amount of memory, iOS may kill it

## Storyboard Lifecycle

`awakeFromNib`:
  - Called before outlets are set and segues are prepared
  - Prefer the View Controller lifecycle methods
  - Primarily for code that needs to execute very early

# Scroll View

A view that allows the user to scroll/pan a viewport around a view larger than
the current screen

## Adding subviews to a UIScrollView

```swift
scrollView.contentSize = CGSize(width: 3000, height: 2000)
logo.frame = CGRect(x: 2700, y: 50, width: 120, height: 180)
scrollView.addSubview(logo)
```
  

