# First Smart Contract With Vue.js

go to the dapps folder and run this

```shell
npx hardhat compile
npx hardhat node
npx hardhat run scripts/deploy.ts --network localhost
npx hardhat run scripts/get.ts --network localhost
```

then run this for the dapps client

```shell
yarn dev
```