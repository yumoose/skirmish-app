# Running inside the development container
Fingers crossed, the installation of all dependencies is taken care of by the Dockerfile. If not, update, test and contribute back!

## Post building steps
Here are some extra steps you can take to develop 100% inside the container

### Firebase CLI Auth
To deploy functions and perform other actions for the Firebase project, you'll need to login to the Firebase CLI,
```
firebase login
```

## Disclaimers
I haven't yet figured out how USB devices on non-Linux installs can be shared, so this is mounting config for VS Code is commented out for now.
```
  // "mounts": [
  //  "source=/dev/bus/usb,target=/dev/bus/usb,type=bind"
  // ],
```
If you're running on a Linux host, feel free to try it out -- no guarantees though.
