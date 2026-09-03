# ChartJS Specialization - Data Visualization

**Agent**: @chartjs  
**Status**: ✅ Production-ready  
**Updated**: 2026-09-03  

---

## 🎯 Expertise

Generate production-ready data visualization code with:
- Chart.js for simple to medium charts
- D3.js for complex custom visualizations
- Recharts for React-native charts
- Responsive design for all devices
- Accessibility (ARIA, labels, keyboard)
- Interactive features (tooltips, zoom, pan)
- Export/download functionality

---

## 🔑 Key Patterns

### Chart.js Line Chart
```javascript
new Chart(ctx, {
  type: 'line',
  data: {
    labels: ['Jan', 'Feb', 'Mar'],
    datasets: [{
      label: 'Sales',
      data: [12, 19, 3],
      borderColor: 'rgb(75, 192, 192)',
      fill: true
    }]
  }
});
```

### React with Recharts
```jsx
<LineChart data={data}>
  <CartesianGrid />
  <XAxis dataKey="month" />
  <YAxis />
  <Tooltip />
  <Legend />
  <Line type="monotone" dataKey="sales" stroke="#3b82f6" />
</LineChart>
```

### D3.js Sunburst
```javascript
d3.select('#chart')
  .selectAll('path')
  .data(root.leaves())
  .enter()
  .append('path')
  .attr('d', arc)
  .attr('fill', d => color(d.parent.data.name));
```

### Responsive Dashboard
```jsx
<ResponsiveContainer width="100%" height={400}>
  <LineChart data={data}>
    {/* Chart components */}
  </LineChart>
</ResponsiveContainer>
```

### Accessible Chart
```jsx
<figure role="img" aria-label="Sales Chart">
  <figcaption>Sales & Profit</figcaption>
  <Chart data={data} />
  <table>
    {/* Data table for screen readers */}
  </table>
</figure>
```

---

## ✅ Checklist

- [ ] Choose right chart type
- [ ] Responsive design
- [ ] Accessibility labels
- [ ] Interactive tooltips
- [ ] Legend & controls
- [ ] Export/download
- [ ] Mobile-friendly
- [ ] Performance (data aggregation)
- [ ] Color accessibility

### Chart Types
- Line: trends over time
- Bar: comparisons
- Pie: composition
- Scatter: correlation
- Bubble: 3D relationships
- Radar: multi-axis

Tags: #visualization #chartjs #d3 #recharts #dashboards #react #accessibility
