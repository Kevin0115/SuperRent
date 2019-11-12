import { GET, POST, DELETE, API_BASE } from './Const';

// API Helper - JUST A TEST FOR NOW
export const postSession = () => {
  fetch(API_BASE, {
    method: POST,
    headers: {
    'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      "dlicense": 9999999,
      "cellphone": 6041234567,
      "name": "John Appleseed",
      "address": "2205 Lower Mall"
    })
  })
  .then(res => res.json())
  .then(json => {
    console.log(json);
  })
  .catch(function(error) {
    console.log('Error posting session: ' + error);
  });
}