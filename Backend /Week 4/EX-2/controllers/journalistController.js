import { journalists  } from "../models/data.js";

export const getAllJournalists = (req, res) => {
    res.status(200).json(journalists);
}

export const getJournalistsById = (req, res) => {
    const id = parseInt(req.params.id);
    const journalist = journalists.find(a => a.id === id);
    if(!journalist){
        return res.status(404).json({
            error: "cant find"
        });
    }
    return res.status(200).json(journalist);
}
export const createNewJournalist = (req, res) => {
    const{name, email} = req.body;
    if(!name || !email){
        return res.status(400).json({
            error: "name and email are required"
        });
    }
const newJournalist = {
    id : journalists.length > 0 ? journalists[journalists.length - 1].id + 1 : 1,name , email
};
journalists.push(newJournalist);
return res.status(201).json(newJournalist);
}
export const updateJournalistByid = (req, res) => {
    const id = parseInt(req.params.id);
    const journalist = journalists.find(a => a.id === id );
    if(!journalist){
        return res.status(404).json({
            error: "cant find"
        });
    }
    const{name , email} = req.body;
if(name){
    journalist.name = name;
}
if(email){
    journalist.email = email;
}
return res.status(200).json(journalist);
}

export const deleteJournalistById = (req, res) => {
const id = parseInt(req.params.id);
const index = journalists.findIndex(j => j.id === id);

if (index === -1) {
  return res.status(404).json({ error: "cant find it" });
}

journalists.splice(index, 1);
return res.status(204).send();
}
