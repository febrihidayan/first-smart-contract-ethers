import { ethers } from "hardhat";

async function main() {
  const contact = await ethers.getContractFactory("Contact");
  const ct = await contact.attach("0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512");

  await ct.createContact('Caca', 'caca@app.com')

  let data = await ct.allContacts()

  data.forEach(item => {
    console.log(item.id)
    console.log(item.name)
    console.log(item.email)
  });

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
