play := playbooks/vm_provision.yaml
inv  := inventories/devops/hosts.init
run:
	ansible-playbook $(play) -i $(inv)
