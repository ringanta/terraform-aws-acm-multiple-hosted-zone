module "acm" {
    source = "../../"

    domains = [
        {
            zone = "example.com"
            domain = "example.com"
        },
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
        Name = "Test ACM request with multiple hosted zones"
    }
}