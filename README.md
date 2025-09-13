# Ansible Project Documentation

## Overview
This Ansible project is designed to automate the configuration and management of servers. It includes a variety of roles, playbooks, and custom modules to facilitate deployment and management tasks.

## Project Structure
The project is organized into the following directories and files:

- **group_vars/**: Contains variables that apply to all hosts in the inventory.
  - `all.yml`: Global variables for all hosts.

- **host_vars/**: Contains variables specific to individual hosts.
  - `example_host.yml`: Host-specific configurations.

- **inventory/**: Defines the inventory of hosts for the Ansible project.
  - `hosts.ini`: Lists hosts and their groups in INI format.

- **modules/**: Contains custom Ansible modules.
  - `custom_module.py`: A custom module to extend Ansible's functionality.

- **playbooks/**: Contains playbooks that define tasks to be executed.
  - `site.yml`: The main playbook for the project.

- **roles/**: Contains reusable roles for organizing tasks and configurations.
  - **common/**: A role that includes common tasks and configurations.
    - **tasks/**: Contains task definitions.
      - `main.yml`: Main tasks for the common role.
    - **handlers/**: Contains handlers for the common role.
      - `main.yml`: Handlers that run when notified.
    - **templates/**: Directory for Jinja2 template files.
    - **files/**: Directory for static files to be copied to hosts.
    - **vars/**: Contains role-specific variables.
      - `main.yml`: Variables for the common role.
    - **defaults/**: Contains default variables for the common role.
      - `main.yml`: Default variables that can be overridden.
    - **meta/**: Contains metadata about the common role.
      - `main.yml`: Role dependencies and metadata.
    - **tests/**: Contains test files for the role.
      - `inventory`: Test inventory for the role.
      - `test.yml`: Test playbook for validating the common role.

- **ansible.cfg**: Configuration file for Ansible, specifying settings such as inventory location and roles path.

- **requirements.yml**: Lists any required Ansible roles or collections for the project.

## Setup Instructions
1. Clone the repository to your local machine.
2. Navigate to the project directory.
3. Install the required Ansible roles and collections using:
   ```
   ansible-galaxy install -r requirements.yml
   ```
4. Update the inventory file (`inventory/hosts.ini`) with your target hosts.
5. Modify the variable files in `group_vars/` and `host_vars/` as needed.
6. Run the playbook using:
   ```
   ansible-playbook playbooks/site.yml
   ```
7. Examples
    ```
    ansible-playbook ./playbooks/http-apache.yaml -i ./inventories/devops/hosts.ini
    ```

## Usage Guidelines
- Ensure that you have Ansible installed on your machine.
- Customize the playbooks and roles according to your environment and requirements.
- Use the `test.yml` playbook in the `tests/` directory to validate the functionality of the roles.

## Contributing
Contributions to this project are welcome. Please submit a pull request or open an issue for any enhancements or bug fixes.