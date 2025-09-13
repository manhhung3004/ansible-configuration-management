play := playbooks/vm_provision.yaml
inv  := inventories/devops/hosts.init
run:
	ansible-playbook $(play) -i $(inv)
clean:
	ansible-playbook playbooks/cleanup.yaml -i $(inv)