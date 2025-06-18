resource "aws_efs_file_system" "moodledata" {
  creation_token = "moodle-efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = true
  tags = {
    Name = "moodle-efs"
  }
}

resource "aws_efs_mount_target" "moodledata" {
  count = length(var.subnet_ids)

  file_system_id  = aws_efs_file_system.moodledata.id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = [var.security_group_id]
}
