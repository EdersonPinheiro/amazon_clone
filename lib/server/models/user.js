const mongoose = require('mongoose');

const userSchema = mongoose.Schema({
    name: {
        required: true,
        type: String,
        trim: true
    },
    email: {
        required: true,
        type: String,
        trim: true,
        validate: {
            validator: (value) => {
                const re = /^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/;
                return value.match(re);
            }, message: 'Por favor entre com um e-mail válido'
        }
    },
    password: {
        required: true,
        type: String,
        /*validate: {
            validator: (value) => {
                return value.lenght > 5;
            }, message: 'Por favor entre com uma senha maior que 6 digitos'
        }*/
    },
    address: {
        type: String,
        default: ''
    },
    type: {
        type: String,
        default: 'user'
    }
});

const User = mongoose.model('User', userSchema);
module.exports = User;