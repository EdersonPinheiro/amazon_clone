const jwt = require('jsonwebtoken');

const auth = async (request, response, next) => {
    try {
        const token = request.header('x-auth-token');
        if(!token) response.status(401).json("Sem token para validação, acesso negado.");

        const verified = jwt.verify(token, "passwordKey");
        if(!verified) return response.status(500).json({msg: "Token para validação falhou, acesso negado."});

        request.user= verified.id;
        request.token = token;
        next();
    } catch(e) {
        print(e);
    }
}

module.exports = auth;