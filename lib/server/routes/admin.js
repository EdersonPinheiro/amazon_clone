const express = require("express");
const adminRouter = express.Router();
//Middleware
const admin = require("../middlewares/adminm");
const { Product } = require("../models/product");

// Add product
adminRouter.post("/admin/add-product", admin, async (req, res) => {
  try {
    const { name, description, images, quantity, price, category } = req.body;
    let product = new Product({
      name,
      description,
      images,
      quantity,
      price,
      category,
    });
    product = await product.save();
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//Get all your product
//  /admin/get-products

adminRouter.get("/admin/get-products", admin, async (request, response) => {
  try {
    const products = await Product.find({});
    response.json(products);
  } catch (e) {
    response.status(500).json({ error: e.message });
  }
});

module.exports = adminRouter;
