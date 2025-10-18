# modules/rds/main.tf

# ========================================
# RDS DB PARAMETER GROUP
# ========================================

# Create custom DB Parameter Group for MySQL
resource "aws_db_parameter_group" "main" {
  name   = "${var.project_name}-mysql-params-${var.environment}"
  family = var.parameter_group_family

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-db-params-${var.environment}"
    }
  )
}

# ========================================
# RDS DB SUBNET GROUP
# ========================================

# DB Subnet Group - Already created in subnets module, so we reference it
# But we can create additional configuration if needed
locals {
  db_subnet_group_name = var.db_subnet_group_name
}

# ========================================
# RDS INSTANCE - PRIMARY
# ========================================

# Create primary RDS instance
resource "aws_db_instance" "primary" {
  identifier = "${var.project_name}-primary-${var.environment}"

  # Database Configuration
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  storage_encrypted = var.storage_encrypted

  # Credentials
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  # Network & Security
  db_subnet_group_name   = local.db_subnet_group_name
  vpc_security_group_ids = [var.database_security_group_id]
  publicly_accessible    = false

  # Backup & Recovery
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window
  copy_tags_to_snapshot   = true

  # High Availability
  multi_az                   = var.multi_az
  auto_minor_version_upgrade = var.auto_minor_version_upgrade

  # Performance Insights (Enhanced Monitoring)
  performance_insights_enabled          = var.performance_insights_enabled
  # performance_insights_retention_period = var.performance_insights_retention_period

  # Deletion Protection
  deletion_protection = var.deletion_protection

  # Enable logging
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  # Skip final snapshot for dev environment
  skip_final_snapshot       = var.environment == "dev" ? true : false
  final_snapshot_identifier = var.environment != "dev" ? "${var.project_name}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}" : null

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-primary-db-${var.environment}"
      Role = "Primary"
    }
  )

  depends_on = [var.db_subnet_group_name]
}

# ========================================
# RDS READ REPLICA - AZ 2
# ========================================

resource "aws_db_instance" "read_replica_az2" {
  identifier = "${var.project_name}-read-replica-az2-${var.environment}"

  # Reference primary instance
  replicate_source_db = aws_db_instance.primary.identifier

  # Instance Configuration
  instance_class = var.read_replica_instance_class

  # Network & Security
  publicly_accessible = false

  # Performance Insights
  performance_insights_enabled = var.performance_insights_enabled

  # Specify AZ for read replica
  availability_zone = var.read_replica_az2

  # Skip snapshot for read replica
  skip_final_snapshot = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-read-replica-az2-${var.environment}"
      Role = "ReadReplica-AZ2"
    }
  )

  depends_on = [aws_db_instance.primary]
}

# ========================================
# RDS READ REPLICA - AZ 3
# ========================================

resource "aws_db_instance" "read_replica_az3" {
  identifier = "${var.project_name}-read-replica-az3-${var.environment}"

  # Reference primary instance
  replicate_source_db = aws_db_instance.primary.identifier

  # Instance Configuration
  instance_class = var.read_replica_instance_class

  # Network & Security
  publicly_accessible = false

  # Performance Insights
  performance_insights_enabled = var.performance_insights_enabled

  # Specify AZ for read replica
  availability_zone = var.read_replica_az3

  # Skip snapshot for read replica
  skip_final_snapshot = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-read-replica-az3-${var.environment}"
      Role = "ReadReplica-AZ3"
    }
  )

  depends_on = [aws_db_instance.primary]
}

# ========================================
# RDS ENHANCED MONITORING ROLE
# ========================================

# IAM Role for RDS Enhanced Monitoring
resource "aws_iam_role" "rds_monitoring_role" {
  name = "${var.project_name}-rds-monitoring-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# Attach AWS managed policy for RDS monitoring
resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# ========================================
# RDS CLUSTER (Optional - for Aurora)
# ========================================

# Uncomment if you want to use Aurora instead of MySQL
/*
resource "aws_rds_cluster" "main" {
  cluster_identifier      = "${var.project_name}-cluster-${var.environment}"
  engine                  = "aurora-mysql"
  engine_version          = "8.0.mysql_aurora.3.02.0"
  database_name           = var.db_name
  master_username         = var.db_username
  master_password         = var.db_password
  db_subnet_group_name    = local.db_subnet_group_name
  vpc_security_group_ids  = [var.database_security_group_id]
  
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.backup_window
  preferred_maintenance_window = var.maintenance_window
  
  skip_final_snapshot = var.environment == "dev" ? true : false
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-aurora-cluster-${var.environment}"
    }
  )
}
*/

# ========================================
# CLOUDWATCH ALARMS FOR RDS
# ========================================

# CPU Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "${var.project_name}-rds-cpu-utilization-${var.environment}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alert when RDS CPU exceeds 80%"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.primary.id
  }

  tags = var.tags
}

# Database Connections Alarm
resource "aws_cloudwatch_metric_alarm" "rds_connections" {
  alarm_name          = "${var.project_name}-rds-db-connections-${var.environment}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alert when database connections exceed 80"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.primary.id
  }

  tags = var.tags
}

# Storage Space Alarm
resource "aws_cloudwatch_metric_alarm" "rds_storage" {
  alarm_name          = "${var.project_name}-rds-free-storage-space-${var.environment}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "2147483648" # 2 GB in bytes
  alarm_description   = "Alert when free storage space is less than 2GB"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.primary.id
  }

  tags = var.tags
}

# Replication Lag Alarm (for read replicas)
resource "aws_cloudwatch_metric_alarm" "rds_replica_lag" {
  alarm_name          = "${var.project_name}-rds-replica-lag-${var.environment}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "AuroraBinlogReplicaLag"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "1000" # milliseconds
  alarm_description   = "Alert when replication lag exceeds 1 second"
  treat_missing_data  = "notBreaching"

  tags = var.tags
}

# ========================================
# LOCAL VARIABLES
# ========================================

locals {
  rds_summary = {
    primary = {
      identifier = aws_db_instance.primary.identifier
      endpoint   = aws_db_instance.primary.endpoint
      port       = aws_db_instance.primary.port
      az         = aws_db_instance.primary.availability_zone
    }
    read_replicas = {
      az2 = {
        identifier = aws_db_instance.read_replica_az2.identifier
        endpoint   = aws_db_instance.read_replica_az2.endpoint
        port       = aws_db_instance.read_replica_az2.port
        az         = aws_db_instance.read_replica_az2.availability_zone
      }
      az3 = {
        identifier = aws_db_instance.read_replica_az3.identifier
        endpoint   = aws_db_instance.read_replica_az3.endpoint
        port       = aws_db_instance.read_replica_az3.port
        az         = aws_db_instance.read_replica_az3.availability_zone
      }
    }
  }
}
