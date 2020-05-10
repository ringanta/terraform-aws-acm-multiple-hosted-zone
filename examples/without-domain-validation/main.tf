module "acm" {
    source = "../../"

    domain_name = {
        zone = "example.com"
        domain = "example.com"
    }
    subject_alternative_names = [
        {
            zone = "example.com"
            domain = "*.example.com"
        },
        {
            zone = "example.org"
            domain = "example.org"
        },
        {
            zone =  "example.org"
            domain = "*.example.org"
        }
    ]

    validation_set_records = false

    tags = {
        Name = "ACM request without setting validation records on Route53"
    }
}