<script setup>
import { ethers } from "ethers";
import { onMounted, reactive } from 'vue'
import abi from './abi'

let signer = null
let provider = null
let contact = null
let state = reactive({
  text: '',
  contacts: [],
  loading: false,
  contact: {
    id: '',
    name: '',
    email: '',
    created_by: '',
  },
})

onMounted(async() => {
  if (window.ethereum == null) {
    provider = ethers.getDefaultProvider()
  } else {
    provider = new ethers.BrowserProvider(window.ethereum)

    signer = await provider.getSigner()

    // change address smart contract
    contact = new ethers.Contract("0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512", abi, provider)
  }

  await loadData()
})

const loadData = async() => {
  state.contacts = await contact.allContacts()
}

const btnSubmit = async() => {
  try {
    state.loading = true
    const yt = await contact.connect(await signer)

    if (state.contact.id != '') {
      await yt.updateContact(state.contact.id, state.contact.name, state.contact.email)
    } else {
      await yt.createContact(state.contact.name, state.contact.email)
    }

    await loadData()
  
    state.contact.id = ''
    state.contact.name = ''
    state.contact.email = ''

    state.loading = false
  } catch (error) {
    console.log(error)
    state.loading = false
  }
}

const btnEdit = async(item) => {
  state.contact.id = item.id
  state.contact.name = item.name
  state.contact.email = item.email
}

const btnDelete = async(id) => {
  try {
    const yt = await contact.connect(await signer)
    await yt.deleteContact(id)
    await loadData()
  } catch (error) {
    console.log(error)
  }
}

</script>

<template>
  <section class="container my-6">
    <form
      @submit.prevent="btnSubmit()">
      <div class="field">
        <label class="label">Full Name</label>
        <div class="control">
          <input
            class="input"
            v-model="state.contact.name"
            type="text"
            placeholder="your name">
        </div>
      </div>
      <div class="field">
        <label class="label">Email</label>
        <div class="control">
          <input
            class="input"
            v-model="state.contact.email"
            type="email"
            placeholder="your email address">
        </div>
      </div>
      <div class="field is-grouped">
        <div class="control">
          <button
            :class="[`button is-link`, {
              'is-loading': state.loading,
            }]" type="submit">Save</button>
        </div>
      </div>
    </form>

    <table class="table is-striped is-hoverable is-fullwidth mt-6">
      <thead>
        <tr>
          <th>#</th>
          <th>Full Name</th>
          <th>Email</th>
          <th>Created By</th>
          <th>Created At</th>
          <th>Updated At</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(item, index) in state.contacts" :key="index">
          <td>{{ item.id }}</td>
          <td>{{ item.name }}</td>
          <td>{{ item.email }}</td>
          <td>{{ item.created_by }}</td>
          <td>{{ item.created_at }}</td>
          <td>{{ item.updated_at }}</td>
          <td class="buttons">
            <button
              @click="btnEdit(item)"
              class="button is-info is-small">Edit</button>
            <button
              @click="btnDelete(item.id)"
              class="button is-danger is-small">Delete</button>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- <p>Address: {{ state.account.address }}</p>
    <p>Text: {{ state.account.text }}</p>
    <p>Balance: {{ state.account.balance }}</p> -->
  </section>
</template>
