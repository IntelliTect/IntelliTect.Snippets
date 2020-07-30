# IntelliTect.Snippets

  

##### *A VSIX extension for sharing code snippets.* [Available in Visual Studio Extension Marketplace](https://marketplace.visualstudio.com/items?itemName=IntelliTect.intellitectsnippets)

  

  

To add a snippet, change the extension of your xml file to `.snippet` and place it in the IntelliTect.Snippets folder associated with the language of the Snippet in the IntelliTect.Snippets project. (e.g. A C# Snippet would be place in the *IntelliTect.Snippets* folder inside the CSharp folder: Snippets -> CSharp -> *IntelliTect.Snippets* ). Then add the shortcut and description of your snippet to the table here in the README. **Be sure to increment the version** of the extension in the `source.extension.vsixmanifest` so that everyone will get the update automatically:
![enter image description here](https://github.com/IntelliTect/IntelliTect.Snippets/blob/master/READMEScreenshots/versionIncrementation.JPG?raw=true)
 

If adding a language you can refer to this [guide for help.](https://docs.microsoft.com/en-us/visualstudio/ide/how-to-distribute-code-snippets?view=vs-2019)


 
### Updates

  

To automatically have the latest IntelliTect.Snippets at you disposal, be sure to have automatic updates enabled for IntelliTect.Snippets in Visual Studio's **Extension Manager**:

![Extension Manager](https://raw.githubusercontent.com/IntelliTect/IntelliTect.Snippets/master/READMEScreenshots/autoUpdateExtensions.JPG)

New snippets that are pulled into Master will automatically be published to the latest version of the IntelliTect.Snippets VSIX extension -> There is a [build pipeline in DevOps](https://intellitect.visualstudio.com/IntelliTect.Snippets/_build) that includes a PowerShell script that publishes the built IntelliTect.Snippets.vsix to the Visual Studio Marketplace. More details about publishing Visual Studio Marketplace extensions can be [found here.](https://docs.microsoft.com/en-us/visualstudio/extensibility/walkthrough-publishing-a-visual-studio-extension-via-command-line?view=vs-2019)

  ### Maintenance 
  For info about dev maintenance of the extension see the [DevFAQ](https://github.com/IntelliTect/IntelliTect.Snippets/blob/master/DevFAQ.md)

## Snippets

  

|Shortcut |Description |
|--|--|
| `NonNullProp` |Code snippit for setting non nullable property |
| | |

