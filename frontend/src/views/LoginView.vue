<script setup lang="ts">
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import LoginComponent from "@/components/authentification/LoginComponent.vue"
import SigninComponent from "@/components/authentification/SigninComponent.vue"
import logo from "@/assets/logo.png"
</script>

<template>
  <main class="w-screen h-screen">
    <div class="flex flex-col w-full h-full items-center gap-10 mt-14">
      <div>
        <img :src="logo" alt="App Logo" class="w-96 my-auto" />
      </div>
      <Tabs default-value="login" class="w-[600px]">
        <TabsList class="grid w-full grid-cols-2">
          <TabsTrigger value="login"> Login </TabsTrigger>
          <TabsTrigger value="signin"> Signin </TabsTrigger>
        </TabsList>
        <TabsContent value="login">
          <LoginComponent />
        </TabsContent>
        <TabsContent value="signin">
          <SigninComponent />
        </TabsContent>
      </Tabs>
    </div>
  </main>
</template>
