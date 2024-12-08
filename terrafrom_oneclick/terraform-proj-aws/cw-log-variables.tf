variable "cw_log_paramters" {
    type = map(object({
        kms_key_id = optional(string),
        retention_in_days = optional(number)
    }))
}