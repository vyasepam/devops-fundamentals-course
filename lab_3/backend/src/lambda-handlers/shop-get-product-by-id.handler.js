
const mockProducts = [
  {
    "count": 1,
    "description": "A very rare product for true lovers",
    "id": "7567ec4b-b43c-48c5-9345-fc73c48a8023",
    "price": 99999999.0,
    "title": "Time machine"
  },
  {
    "count": 1,
    "description": "A rarely used spare tier",
    "id": "8888ec4b-b43c-48c5-9345-fc73c48a8023",
    "price": 1.99,
    "title": "Spare tire"
  },
  {
    "count": 4,
    "description": "Short Product Description1",
    "id": "7567ec4b-b10c-48c5-9345-fc73c48a80aa",
    "price": 2.4,
    "title": "ProductOne"
  },
  {
    "count": 6,
    "description": "Short Product Description3",
    "id": "7567ec4b-b10c-48c5-9345-fc73c48a80a0",
    "price": 10,
    "title": "ProductNew"
  },
  {
    "count": 7,
    "description": "Short Product Description2",
    "id": "7567ec4b-b10c-48c5-9345-fc73c48a80a2",
    "price": 23,
    "title": "ProductTop"
  },
  {
    "count": 12,
    "description": "Short Product Description7",
    "id": "7567ec4b-b10c-48c5-9345-fc73c48a80a1",
    "price": 15,
    "title": "ProductTitle"
  },
  {
    "count": 7,
    "description": "Short Product Description2",
    "id": "7567ec4b-b10c-48c5-9345-fc73c48a80a3",
    "price": 23,
    "title": "Product"
  },
  {
    "count": 8,
    "description": "Short Product Description4",
    "id": "7567ec4b-b10c-48c5-9345-fc73348a80a1",
    "price": 15,
    "title": "ProductTest"
  },
  {
    "count": 2,
    "description": "Short Product Descriptio1",
    "id": "7567ec4b-b10c-48c5-9445-fc73c48a80a2",
    "price": 23,
    "title": "Product2"
  },
  {
    "count": 3,
    "description": "Short Product Description7",
    "id": "7567ec4b-b10c-45c5-9345-fc73c48a80a1",
    "price": 15,
    "title": "ProductName"
  }
];

exports.handler = async (event, ctx) => {
  const productId = event.pathParameters.id;
  const product = mockProducts.find(p => p.id === productId);

  let response = product ? {
    statusCode: 200,
    body: JSON.stringify(product),
  } : {
    statusCode: 404,
    body: `Product with ID: ${ productId } is not found.`
  };

  return response;
};
