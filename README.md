# WorkspaceScriptAssist-CMD

This repository contains a set of scripts to automate the management of project directories on Windows. The scripts include `create-project`, `manage-project`, and `delete-project` for creating, managing, and deleting project directories respectively.

## Table of Contents

- [WorkspaceScriptAssist-CMD](#workspacescriptassist-cmd)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Requirements](#requirements)
  - [Usage](#usage)
  - [Scripts Overview](#scripts-overview)
  - [Contributing](#contributing)
  - [License](#license)

## Features

- **create-project:** Automates the creation of project directories and their configurations.
- **manage-project:** Provides functionality to manage existing project directories, including updating configurations.
- **delete-project:** Safely removes project directories and associated configurations.

## Requirements

- Windows operating system.
- Administrative privileges to create and delete directories.
- Command Prompt or PowerShell.

## Usage

1. Clone or download this repository to your local machine.
2. Open Command Prompt or PowerShell with administrative privileges.
3. Navigate to the directory containing the scripts.
4. Run the desired script using the following commands:

   ```batch
   create-project.cmd
   manage-project.cmd
   delete-project.cmd
   ```

5. To add the directory containing the scripts to your global PATH variable:

   - Open Control Panel.
   - Go to System and Security > System.
   - Click on "Advanced system settings" on the left panel.
   - In the System Properties window, click on the "Environment Variables" button.
   - Under "System variables", select the "Path" variable and click "Edit".
   - Add the path to the directory containing the scripts to the list of paths, separated by semicolons.
   - Click "OK" to save the changes.

6. Follow the on-screen prompts to perform the desired action on project directories.

## Scripts Overview

- **create-project:** This script guides the user through creating a new project directory, linking it with platforms, organizations, languages, and frameworks.
- **manage-project:** Allows users to manage existing project directories by updating their configurations or making changes to linked entities.
- **delete-project:** Safely removes project directories, ensuring that linked configurations are appropriately handled to prevent data loss.

## Contributing

Contributions are welcome! If you encounter any issues or have suggestions for improvements, please open an issue or submit a pull request on GitHub.

## License

[MIT License](LICENSE)

---

Feel free to customize the README further to better fit your project's specific requirements and provide any additional information or instructions as needed.

```

```
