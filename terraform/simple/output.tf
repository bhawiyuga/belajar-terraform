resource "local_file" "AnsibleInventory" {
    filename = "inventory"
    content = templatefile("inventory.tmpl",
        {
            pub_instance = aws_instance.pub_instance,
            username = "ubuntu"
        }
    )
}