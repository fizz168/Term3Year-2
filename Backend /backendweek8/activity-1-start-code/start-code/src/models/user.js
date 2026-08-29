import { DataTypes } from "sequelize";
import sequelize from "../db/database.js";


// // TODO - Create the model User  (attributes name and age) ti 1
// // const User = sequelize.define("User", {
// //     name: DataTypes.STRING,
// //     age: DataTypes.INTEGER
// // });


// // create class user
// const User = sequelize.define("User", { // ti2 
// name: DataTypes.STRING,
// age: {
//     type: DataTypes.INTEGER,
//     allowNull: false,
// },
// });
// // synchronise with database 
// let result = await sequelize.sync({alter: true });

// //create instance 
// const nigga = await User.build({name : "nigga", age: 30});
 
// // validate instance 
// result = await nigga.save();

// nigga.name = "ronan";

// result = await nigga.save();

// // delete 
// await User.destroy({where: {name:'nigga'}});
// await User.destroy({where: {}});
// console.log(result);
const User = sequelize.define('User', {
 username: DataTypes.STRING,
 email: DataTypes.STRING
});
const Profile = sequelize.define('Profile',
{
 bio: DataTypes.TEXT,
 avatarUrl: DataTypes.STRING
});
User.hasOne(Profile);
Profile.belongsTo(User);


const user = await User.create({ username: 'visal',
email: 'v@x.com' });
await user.createProfile({ bio: 'Hi!', avatarUrl:
'url' });
// FETCH
const userWithProfile = await User.findOne();
console.log(userWithProfile.Profile.bio);

// TODO - Export the model User
export default User;
