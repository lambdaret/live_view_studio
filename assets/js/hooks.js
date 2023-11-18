let Hooks = {}

Hooks.StashForm = {
  // beforeDestroy() {
  destroyed() {
    console.log("Hooks.StashForm beforeDestroy")
    const formData = new FormData(this.el)
    const params = Object.fromEntries(formData.entries())
    this.pushEvent("stashForm", params)
  },
}

export default Hooks
