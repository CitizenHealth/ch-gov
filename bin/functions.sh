function hack {
    docker-compose -p ch-gov-hack -f vm/docker-compose.hack.yml up -d
}

function cleanup-hack {
    docker-compose -p ch-gov-hack -f vm/docker-compose.hack.yml kill
    docker-compose -p ch-gov-hack -f vm/docker-compose.hack.yml rm -f
}
