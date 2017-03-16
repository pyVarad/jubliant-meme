## Select the node - hostname ##

node 'flask-backend-app' {
    if $operatingsystem == 'CentOS' {
      include cabriolet::commonrhel
    }
    include cabriolet::webapp
}
node 'ming-backend-app' {
    if $operatingsystem == 'CentOS' {
      include cabriolet::commonrhel
    }
    include cabriolet::mongo
}
