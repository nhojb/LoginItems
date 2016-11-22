# LoginItems

A mini framework written in Swift to provide access to the LaunchServices login items API.

### Usage:

    // Add your app to the users list of Login Items
    LaunchItemsManager.shared.startAtLogin = true

Alternatively add a LaunchItemsManager object to your xib file and then bind a checkbox to
"Launch Items Manager" using the model key path "self.startAtLogin".

### Note
The LaunchServices APIs used have been depracted since macOS 10.11 and will only
work in non-sandboxed apps.

However this seems a bad idea to me, as the only supported alterative for apps is to run 
a deamon via launchctl - which is not visible to most users. YMMV.
