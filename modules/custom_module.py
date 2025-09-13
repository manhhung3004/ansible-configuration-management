def main():
    module = AnsibleModule(
        argument_spec=dict(
            name=dict(type='str', required=True),
            state=dict(type='str', choices=['present', 'absent'], default='present'),
        )
    )

    name = module.params['name']
    state = module.params['state']

    if state == 'present':
        # Logic to ensure the resource is present
        module.exit_json(changed=True, msg=f"{name} is created.")
    else:
        # Logic to ensure the resource is absent
        module.exit_json(changed=True, msg=f"{name} is deleted.")

if __name__ == '__main__':
    main()