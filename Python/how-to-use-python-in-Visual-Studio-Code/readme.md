# Install

* Install Python 3.4.3 from [here](https://www.python.org/downloads/release/python-343)
* Install Python extension(by DonJayamanne) for Visual Studio Code

# Config

* Config settings.json and launch.json as follows

```json
// settings.json
// Place your settings in this file to overwrite default and user settings.
{
    "python.pythonPath": "c:/python34/python.exe"
}

// launch.json
// detail from https://github.com/DonJayamanne/pythonVSCode/wiki/Debugging
{
    "name": "Python",
    "type": "python",
    "pythonPath":"${config.python.pythonPath}", 
    "request": "launch",
    "stopOnEntry": true,
    "externalConsole":false,
    "program": "${file}",
    "cwd": "${workspaceRoot}",
    "debugOptions": [
        "WaitOnAbnormalExit",
        "WaitOnNormalExit",
        "RedirectOutput"
    ],
    "env": {"name":"value"}
}

```



 


