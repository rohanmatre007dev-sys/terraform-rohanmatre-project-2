🎯 Problem Statement

Modern applications require:

Scalability without managing servers
Event-driven processing
Loose coupling between services
High availability and fault tolerance
Observability and monitoring
❗ Challenges Solved:
Manual AWS setup is error-prone ❌
Tight coupling between services ❌
Difficult to scale and maintain ❌
No standard reusable infrastructure ❌
✅ Solution

This project solves the above problems by:

✔ Using Terraform wrappers for modular infrastructure
✔ Designing an event-driven architecture
✔ Automating AWS infrastructure deployment
✔ Ensuring loose coupling using SQS, SNS, EventBridge
✔ Adding observability via CloudWatch
✔ Using Step Functions for orchestration

🏗️ Architecture
Flow:
User → CloudFront → API Gateway
API Gateway → Lambda (Main)
Lambda → DynamoDB
Lambda → EventBridge (optional events)
EventBridge → SQS
SQS → Lambda Worker
SNS → Notifications
Step Functions → Orchestration
CloudWatch → Monitoring & Logs
⚙️ Tech Stack
Terraform (Infrastructure as Code)
AWS Services:
VPC
API Gateway
Lambda
DynamoDB
SQS + DLQ
SNS
EventBridge
Step Functions
CloudFront
IAM
CloudWatch
📦 Terraform Modules Used

All modules are custom wrappers:

vpc
lambda
apigw
cloudfront
dynamodb
sqs
sns
eventbridge
step-functions
iam
🚀 Deployment Steps

# 1. Initialize Terraform

terraform init

# 2. Format code

terraform fmt

# 3. Validate

terraform validate

# 4. Plan

terraform plan

# 5. Apply

terraform apply
🔐 IAM & Security
Custom IAM wrapper module
Principle of least privilege
API Gateway logging enabled via IAM role
Secure service-to-service communication
📊 Observability
CloudWatch Logs
API Gateway access logs
Lambda logs
Event tracking via EventBridge
🧠 Key Learnings
Designing event-driven architectures
Creating Terraform wrapper modules
Managing cross-service dependencies
Debugging real-world Terraform issues
Handling AWS service limitations (IAM, API GW, etc.)
💡 Highlights

✔ Fully modular Terraform architecture
✔ Reusable wrapper modules
✔ Production-ready design
✔ No manual AWS setup
✔ End-to-end automation

📌 Future Improvements
Add CI/CD (GitHub Actions)
Add custom domain with Route53
Add WAF for security
Add monitoring dashboards
👨‍💻 Author

Rohan Matre

⭐ If you like this project

Give it a ⭐ on GitHub!
