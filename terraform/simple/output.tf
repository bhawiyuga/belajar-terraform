resource "local_file" "AnsibleInventory" {
    filename = "../../gitlab-cicd/staticweb/ansible/inventory.yaml"
    content = templatefile("inventory.tmpl",
        {
            pub_instance = aws_instance.pub_instance,
            username = "ubuntu"
        }
    )
}