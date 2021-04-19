resource "local_file" "AnsibleInventory" {
    filename = "../../ansible/playbook/inventory.yaml"
    content = templatefile("inventory.tmpl",
        {
            pub_instance = aws_instance.pub_instance,
            username = "ubuntu"
        }
    )
}