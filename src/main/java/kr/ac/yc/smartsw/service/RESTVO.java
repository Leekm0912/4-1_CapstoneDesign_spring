package kr.ac.yc.smartsw.service;

public class RESTVO {

	private String id;
	private String title;
	private String text;
	private String image;
	private String csv;
	
	public RESTVO() {
		
	}
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
	public String getCsv() {
		return csv;
	}
	public void setCsv(String csv) {
		this.csv = csv;
	}

	@Override
	public String toString() {
		return "RESTVO [id=" + id + ", title=" + title + ", text=" + text + ", image=" + image + ", csv=" + csv + "]";
	}
	
}
