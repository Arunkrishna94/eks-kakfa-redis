resource "aws_efs_file_system" "redis_efs" {
  creation_token = "${var.cluster_name}-efs"
}

resource "aws_efs_mount_target" "redis_efs_mount" {
  for_each      = toset(aws_subnet.eks_subnet[*].id)
  file_system_id = aws_efs_file_system.redis_efs.id
  subnet_id      = each.key
}

resource "kubernetes_storage_class" "efs_sc" {
  metadata {
    name = "efs-sc"
  }
  provisioner = "efs.csi.aws.com"
}

resource "kubernetes_persistent_volume" "efs_pv" {
  metadata {
    name = "efs-pv"
  }
  spec {
    capacity {
      storage = "5Gi"
    }
    access_modes = ["ReadWriteMany"]
    storage_class_name = "efs-sc"
    persistent_volume_source {
      nfs {
        path       = "/"
        server     = aws_efs_file_system.redis_efs.dns_name
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "efs_pvc" {
  metadata {
    name = "efs-pvc"
  }
  spec {
    access_modes      = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "5Gi"
      }
    }
    storage_class_name = "efs-sc"
  }
}
