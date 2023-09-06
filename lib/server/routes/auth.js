const express = require("express");
const User = require("../models/user");
const bcryptjs = require("bcryptjs");
const authRouter = express.Router();
const jwt = require("jsonwebtoken");
const auth = require("../middlewares/auth");

authRouter.post('/api/signup', async (request, response) => {
    try {
        const { name, email, password } = request.body;

        const existingUser = await User.findOne({ email });

        if (existingUser) {
            return response.status(400).json({ msg: "Já existe um usuário vinculado a esse e-mail" });
        }

        const hashedPassword = await bcryptjs.hash(password, 8);

        let user = new User({
            name,
            email,
            password: hashedPassword
        });

        user = await user.save();

        return response.status(200).send();
    } catch (e) {
        response.status(500).json({ error: e.message });
    }
});

authRouter.post('/api/signin', async (request, response) => {
    try {

        const { email, password } = request.body;

        const user = await User.findOne({ email });

        if (!user) {
            return response.status(400).json({ msg: "Não existe nenhum usuário vinculado a este endereço de e-mail." })
        }

        const isMatch = bcryptjs.compare(password, user.password);

        if (!isMatch) {
            return response.status(400).json({ msg: "Senha incorreta." })
        }

        const token = jwt.sign({ id: user._id }, "passwordKey");

        response.json({ token, ...user._doc });
    } catch (e) {
        response.status(500).json({ error: e.message });
    }
});

authRouter.post('/api/tokenIsValid', async (request, response) => {
    try {
        const token = request.header('x-auth-token');
        if (!token) throw new Error("Não possui token");
        const verified = jwt.verify(token, 'passwordKey');
        if (!verified) throw new Error("Token inválido");
        const user = await User.findById(verified.id);
        if (!user) throw new Error("Usuário inexistente");
        response.json(user);
    } catch (e) {
        response.status(500).json({ error: e.message });
    }
});

authRouter.get('/api/home', auth, async (request, response) => {
    const user = await User.findById(request.user);
    response.json({ ...user._doc, token: request.token });
});

module.exports = authRouter;
