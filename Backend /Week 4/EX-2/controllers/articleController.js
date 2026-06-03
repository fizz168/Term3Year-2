import { articles } from "../models/data";

app.get('/users', (req, res) => {
  res.status(200).json(users);
});

app.get('/users/:id', (req, res) => {
 const id = parseInt(req.params.id);
 const user = users.find(user => user.id === id);
 if(!user){
  return res.status(404).json({
    error: "user not found"
  });
 }
 res.status(200).json(user);
})

app.post('/users', (req, res) => {
const {title, content, journalistId, categoryId} = req.body;
if(!title || !content || !journalistId ||  !categoryId){
  return res.status(400).json({
     error:"user not found"
  });
}app.put('/user/:id',(req, res) => {
const id =  parseInt(req.params.id);
const user = user.find(user => user.id === id );
if(!user){
  return res.status(404).json({
    error: "user not found"
  });
}
if(name){
  user.name = name;
}
if(email){
  user.email = email;
}
return res.status(200).json(users);
});

app.delete('/user/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const user = user.find(user =>user.id === id);
  if(!user){
  return res.status(404).json({
    error: "user not found"
  });
}
if(name){
  user.name = name;
}
if(email){
  user.email = email;
}
return res.status(204).json(users);

})
const newUser = {
  id : users.lenght > 0 
  ? users[users.length - 1].id + 1 : 1, name,email
}
users.push(newUser);
return res.status(201).json(users)
});

app.put('/user/:id',(req, res) => {
const id =  parseInt(req.params.id);
const user = user.find(user => user.id === id );
if(!user){
  return res.status(404).json({
    error: "user not found"
  });
}
if(name){
  user.name = name;
}
if(email){
  user.email = email;
}
return res.status(200).json(users);
});

app.delete('/user/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const user = user.find(user =>user.id === id);
  if(!user){
  return res.status(404).json({
    error: "user not found"
  });
}
if(name){
  user.name = name;
}
if(email){
  user.email = email;
}
return res.status(204).json(users);

});
export default ar