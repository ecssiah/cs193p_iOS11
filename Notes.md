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
  
The view can be scrolled programatically:

```swift
func scrollRectToVisible(CGRect, animated: Bool)
```

The `contentSize` can also be zoomed. This requires the minimum and maximum zoom
scales to be set

```swift
scrollView.minimumZoomScale = 0.5
scrollView.maximumZoomScale = 2.0
```

Zooming also requires a delegate method to specificy which subview will be 
scaled

```swift
func viewForZooming(in scrollView: UIScrollView) -> UIView
```

The view can be zoomed programatically:

```swift
var zoomScale: CGFloat
func setZoomScale(CGFloat, animated: Bool)
func zoom(to rect: CGRect, animated: Bool)
```

UIScrollView has a number of delegate methods that provide information

```swift
scrollViewDidEndZooming(
  UIScrollView,
  with view: UIView,
  atScale: CGFloat
)
```

This could be used to increase resolution after the user zooms past a certain
scale. If this is done, then the transform will usually be set back to the 
identity matrix.

# Multithreading

iOS multithreading utilizes 'queues' of functions (often closures). They can 
either be executed in serial or concurrently.

## Main Queue

All UI activity is run in the "main queue", so heavy non-UI processes must be 
kept out of this queue to avoid freezing the UI.

Accessing the main queue:

```swift
let mainQueue = DispatchQueue.main
```

## Global Queues

There are four global queues available based on their 'quality of service'.

```swift
let backgroundQueue = DispatchQueue.global(qos: DispatchQoS)

DispatchQoS.userInteractive // high priority, short and quick tasks
DispatchQoS.userInitiated   // high priority, normal tasks
DispatchQoS.background      // not directly initiated by user, long tasks
DispatchQoS.utility         // low priority, long-running background tasks
```

## Adding to a Queue

To add a function while continuing to run the current queue:

```swift
queue.async { ... }
```

To add a function and block the current queue until it is completed:

```swift
queue.sync { ... }
```

## Multithreaded iOS API

iOS will often run processes off the main queue and offer the developer the
option to run a closure that will execute off the main queue.

__It is important to dispatch any UI work back to the main queue in these 
closures__





