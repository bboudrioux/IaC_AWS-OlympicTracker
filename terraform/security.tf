# Security Groups
resource "aws_security_group" "haproxy_sg" {
  name        = "${var.project_name}-haproxy-sg"
  description = "HAProxy - Entree depuis Admin"

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.current_user_ip]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [local.current_user_ip]
  }

  egress {
    description = "Allow HTTP for updates"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow HTTPS for updates"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_sg" {
  name   = "${var.project_name}-app-sg"

  egress {
    description = "Allow HTTP for updates"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow HTTPS for updates"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elk_sg" {
  name   = "olympic-tracker-elk-sg"

  ingress {
    description = "Kibana from Admin"
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = [local.current_user_ip]
  }

  egress {
    description = "Allow HTTP for updates"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow HTTPS for updates"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# HAProxy -> App (HTTP/HTTPS)
resource "aws_security_group_rule" "haproxy_to_app_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.haproxy_sg.id
}

resource "aws_security_group_rule" "haproxy_to_app_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.haproxy_sg.id
}

# HAProxy <-> App (SSH Bastion)
resource "aws_security_group_rule" "haproxy_to_app_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.haproxy_sg.id
}

resource "aws_security_group_rule" "haproxy_egress_ssh_to_internal" {
  type                     = "egress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.haproxy_sg.id
  source_security_group_id = aws_security_group.app_sg.id
}

# HAProxy <-> ELK (SSH Bastion)
resource "aws_security_group_rule" "haproxy_to_elk_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.elk_sg.id
  source_security_group_id = aws_security_group.haproxy_sg.id
}

resource "aws_security_group_rule" "haproxy_egress_ssh_to_elk" {
  type                     = "egress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.haproxy_sg.id
  source_security_group_id = aws_security_group.elk_sg.id
}

# App <-> ELK (Elasticsearch/Logstash)
resource "aws_security_group_rule" "app_to_elk_logs" {
  type                     = "ingress"
  from_port                = 5044
  to_port                  = 5044
  protocol                 = "tcp"
  security_group_id        = aws_security_group.elk_sg.id
  source_security_group_id = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "app_egress_to_elk" {
  type                     = "egress"
  from_port                = 5044
  to_port                  = 5044
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.elk_sg.id
}

# App -> ELK (GELF/Graylog)
resource "aws_security_group_rule" "allow_gelf_from_app" {
  type                     = "ingress"
  from_port                = 12201
  to_port                  = 12201
  protocol                 = "udp"
  security_group_id        = aws_security_group.elk_sg.id
  source_security_group_id = aws_security_group.app_sg.id
}