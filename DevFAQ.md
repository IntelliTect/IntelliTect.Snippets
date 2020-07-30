# DevFAQ

The publishing of IntelliTect.Snippets to the Visual Studio Marketplace is done through its [associated DevOps pipeline](https://intellitect.visualstudio.com/IntelliTect.Snippets). 

The pipeline yaml script runs whenever Master is updated. It build the IntelliTect.Snippets solution and then has a `PublishVisualStudioExtension@3` task ([See Azure DevOps Extension Tasks](https://marketplace.visualstudio.com/items?itemName=ms-devlabs.vsts-developer-tools-build-tasks)). This task requires that the IntelliTect.Snippets azure project has access to a Visual Studio Marketplace Service Connection ([Found in Project Settings -> Service Connections](https://github.com/IntelliTect/IntelliTect.Snippets/blob/master/READMEScreenshots/required%20Marketplace%20service%20connection.JPG?raw=true)).
The service connection then requires a PAT  created at the Organization (IntelliTect) level. 
[How to create an Azure PAT for Visual Studio marketplace](https://docs.microsoft.com/en-us/azure/devops/extend/publish/command-line?view=azure-devops)

**If the publishing task is failing, check to see if the PAT has expired **

The Associated Visual Studio Marketplace Publisher ID is `IntelliTect`

