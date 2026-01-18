function validateUsername(username) {
  if (!username) return false;
  if (username.length < 2 || username.length > 30) return false;
  return /^[a-zA-Z0-9._]+$/.test(username);
}

module.exports = { validateUsername };
