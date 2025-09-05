window.addEventListener('message', function(event){
    if(event.data.action === "openTablet"){
        const tablet = document.getElementById("tablet");
        const container = document.getElementById("tradeContainer");
        container.innerHTML = "";
        event.data.trades.forEach(recipe => {
            const itemDiv = document.createElement("div");
            itemDiv.className = "trade-item";
            itemDiv.innerHTML = `<img src="${recipe.image}" /><span>${recipe.label}</span>`;
            itemDiv.onclick = () => {
                fetch(`https://${GetParentResourceName()}/tradeItem`, {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ recipe })
                });
            };
            container.appendChild(itemDiv);
        });
        tablet.classList.add("show");
    }
});
document.getElementById("closeBtn").addEventListener("click", () => {
    const tablet = document.getElementById("tablet");
    tablet.classList.remove("show");
    fetch(`https://${GetParentResourceName()}/closeTablet`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({})
    });
});
