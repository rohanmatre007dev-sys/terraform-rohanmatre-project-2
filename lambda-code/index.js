exports.handler = async (event) => {
  return {
    statusCode: 200,
    headers: {
      "Content-Type": "text/html",
    },
    body: `
      <html>
        <head>
          <title>Event Booking</title>
          <style>
            body { font-family: Arial; text-align: center; }
            .card { border: 1px solid #ccc; padding: 20px; margin: 20px; }
            button { padding: 10px 20px; background: red; color: white; border: none; }
          </style>
        </head>
        <body>
          <h1>🎬 Book My Event</h1>

          <div class="card">
            <h2>Avengers Movie</h2>
            <p>Location: Ahmedabad</p>
            <p>Time: 7:00 PM</p>
            <button onclick="alert('Booked!')">Book Now</button>
          </div>

        </body>
      </html>
    `,
  };
};
