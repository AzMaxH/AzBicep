# Bicep Modules Collection

Welcome to the **Bicep Modules Collection** repository. This repository contains a collection of open-source [Bicep](https://github.com/Azure/bicep) modules designed to simplify and automate Azure infrastructure deployment. These modules are publicly available and licensed under the **GNU General Public License v3.0**.

## Purpose

The purpose of this project is to provide modular and reusable Bicep modules for common Azure infrastructure configurations, making it easier for developers and architects to manage their projects.

## Features

- **Easily Reusable**: The modules are designed to be quickly integrated into your own Bicep configurations
- **Well Documented**: Each module includes documentation describing parameters, usage examples, and best practices
- **Azure Compatibility**: Tested and validated to work with the latest versions of Azure Resource Manager (ARM)

## Prerequisites

- **Azure CLI** (version 2.20.0 or later)
- **Bicep CLI** (version 0.4.412 or later)
- An active Azure subscription

## Installation

To use a module from this repository in your own project:

1. Clone this repository:
   ```bash
   git clone https://github.com/username/BicepModulesCollection.git
   cd BicepModulesCollection

2. Import the module into your main Bicep file using the relative path

## Available Modules
Modules Disponibles
|   Module        |   Description	                                                      |   Version |
|-----------------|---------------------------------------------------------------------|-----------|
|   vnet.bicep  	|   Bicep module for creating a virtual network on Azure	            |   1.0.0   |
|   nsg.bicep	    |   Bicep module for creating a Network Security Group on Azure	      |   1.0.0   |
|   asg.bicep	    |   Bicep module for creating an application security group on Azure	|   1.0.0   |
|   rt.bicep	    |   Bicep module for creating a route table in Azure	                |   1.0.0   |

Each module includes usage examples and specific configuration information in its own README file.

## Usage

Here is a basic example of using a module in your Bicep file:
```bicep
module vnet 'modules/module1.bicep' = {
  name: 'myVnetModule'
  params: {
    // specific parameters
  }
}
```

## Contributing
Contributions are welcome! Please follow the steps below to contribute:

1. Fork the repository
2. Create a feature branch (git checkout -b feature/new-feature)
3. Make your changes and document them
4. Submit a pull request with a clear explanation of the changes

## License

This project is licensed under the GNU General Public License v3.0. See the LICENSE file for more details.

## Authors and Acknowledgements

This repository is maintained by Maxence Holvoet. Thanks to all contributors who help improve and enrich this collection