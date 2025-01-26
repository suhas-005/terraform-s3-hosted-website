variable "s3_name" {
    type = string
    description = "S3 bucket name"
}

variable "s3_obj_index_page_key" {
    type = string
    description = "S3 index.html obj key"
}

variable "s3_obj_index_page_path" {
    type = string
    description = "S3 index.html source file path"
}

variable "s3_obj_error_page_key" {
    type = string
    description = "S3 error.html obj key"
}

variable "s3_obj_error_page_path" {
    type = string
    description = "S3 error.html source file path"
}