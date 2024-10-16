<script setup lang="ts">
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import LoginComponent from "@/components/authentification/LoginComponent.vue"
import SigninComponent from "@/components/authentification/SigninComponent.vue"
</script>

<template>
  <main class="w-screen h-screen">
    <div class="flex w-full h-full justify-center mt-52">
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
