# View Controller Lifecycle

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
    ```
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)

      ...
    }
    ```

  - Start observing something like GPS position
  - Useful for starting expensive procedures that shouldn't run until visible


