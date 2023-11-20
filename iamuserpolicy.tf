resource "aws_iam_user_policy_attachment" "cicd-ecs-access" {
    depends_on = [ aws_iam_user.cicd-jenkins ]
    user       = "cicd-jenkins"
    policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_user_policy_attachment" "cicd-ec2-access" {
    depends_on = [ aws_iam_user.cicd-jenkins ]
    user       =  "cicd-jenkins"
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}