data "aws_route53_zone" "selected" {
  # name         = "test.com."
  name         = var.domain_name
  private_zone = false
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.1.1"

  domain_name = var.domain_name
  zone_id = "${data.aws_route53_zone.selected.zone_id}"

  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain_name}",
    # "*.my-domain.com",
    # "app.sub.my-domain.com",
  ]
  
  # Need to  Create DNS Validate thru AWS Console manually , 
  # when wait_for_validation = true , you need to switch to AWS console to approval dns record first  # 
  # wait_for_validation = true
  # wait_for_validation = false

  #create_route53_records  = true
  #validation_record_fqdns = module.route53_records.validation_route53_record_fqdns

  tags = {
    Name =  "${var.domain_name}"
  }

}